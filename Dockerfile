# Use official Python image
FROM python:3.11-slim

# Set working directory inside container
WORKDIR /app

# Copy full project files into container
COPY . /app/

# Move into correct Django app folder
WORKDIR /app/app

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r /app/requirements.txt

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose port 8000
EXPOSE 8000

# Run the server (using gunicorn)
CMD ["gunicorn", "app.wsgi:application", "--bind", "0.0.0.0:8000"]
