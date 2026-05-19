FROM python:3.13-slim

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# git is required because pip installs limoon from a git reference
# (the app targets limoon's git main, newer than any PyPI release).
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

COPY . .

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir hatchling && \
    pip install --no-cache-dir . && \
    pip install --no-cache-dir --upgrade "curl-adapter>=1.2.1"

# limoon pins the broken curl-adapter==1.1.0; the separate upgrade above
# replaces it with a working version (isolated step => only a warning, no
# ResolutionImpossible).

EXPOSE 5000

CMD ["gunicorn", "src.ozgursozluk.main:app", "-b", "0.0.0.0:5000", "-w", "5"]
