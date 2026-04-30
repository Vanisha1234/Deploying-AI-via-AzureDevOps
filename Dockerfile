FROM python:3.11                                             # Base image with Python 3.11 pre-installed

ENV PYTHONDONTWRITEBYTECODE=1                                # Prevent Python from writing .pyc (compiled) files → reduces unnecessary files
ENV PYTHONUNBUFFERED=1                                       # Ensures logs/output are printed directly (no buffering) → useful for Docker logs

WORKDIR /app                                                 # Sets working directory inside container to /app

COPY requirements.txt /app/                                  # Copy only requirements first (helps Docker caching → faster rebuilds)
RUN apt-get update && \
    apt-get install -y libpq-dev gcc && \                    # libpq-dev → PostgreSQL support, gcc → for compiling packages
    apt-get clean && \                                       # Cleans apt cache to reduce image size
    rm -rf /var/lib/apt/lists/*                              # Removes leftover package lists

RUN pip install --no-cache-dir --upgrade pip                 # Upgrade pip to latest version
RUN pip install --no-cache-dir -r requirements.txt           # Install Python dependencies from requirements.txt

COPY . /app/                                                 # Copy entire project code into container

EXPOSE 8000                                                  # Expose port 8000 (Django runs on this port)

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]     # Default command → runs Django development server
