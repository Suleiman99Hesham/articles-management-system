# Use official Python image
FROM python:3.11-slim-bookworm

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory inside container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    netcat-openbsd gcc postgresql-client libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy full project files into container
COPY . /app/

# Move into correct Django app folder
WORKDIR /app/app

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

# Expose port 8000
EXPOSE 8000

# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/app/entrypoint.sh"]