# http.sh

## start
```bash
./run.sh
```

## Idee
- Antworten liegen unter responses.d/
- Baumstruktur dem angefragten Pfad entsprechend
- statische Files (GET, POST, some-name)
- Skripte (something.sh)
- Query Parameter übergeben (Wie?)

|method|path|responses.d|
|-|-|-|
|GET|/|responses.d/GET|
|GET|/auth|responses.d/auth/GET|
|GET|/auth/login.html|responses.d/auth/login.html/GET|
|POST|/auth/login|responses.d/auth/login/POST|
|GET|/auth/login.html|responses.d/auth/login.html/redirect.sh|


