FROM kennethreitz/pipenv

COPY . /app

EXPOSE 8080

CMD python3 app.py
