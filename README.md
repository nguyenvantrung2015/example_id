# README

### How to run this project in localhost

1. Copy .env file from .env.example file and fill all
2. Run this command
```
$ openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 -keyout localhost.key -out localhost.crt
$ rails s -b 'ssl://localhost:3000?key=localhost.key&cert=localhost.crt'
```

