# Description
Create a docker container with antigravity agent inside

## Build image
```shell
docker build -t agy-sandbox .
```

## Start agent
By default the workspace where the sandbox will created is called workspace. Execute the command inside your working folder to attach the volumen to your working folder.

Create a simple working folder called poc-greeting to save our code
```shell
mkdir poc-greeting
```

We can execute our agent container in two modes interactive and auto-pilot mode:

- Execute our agent container in **interactive mode**. We must select the color theme, the license and accept permissions for our working folder:

  ```shell
  docker run --rm -it \
    --cap-drop=ALL --security-opt no-new-privileges \
    -v "$PWD":/workspace \
    agy-sandbox agy --dangerously-skip-permissions
  ```

  The agent show a antigravity link to copy and paste in our chrome and obtain our access token to login in our account. Paste this token and permit the interaction of our agent with our working space localed in the docker volumne. In this case the agent only will have access the volume:

  ```shell
  The agent will show an antigravity link to copy and paste in our web browser to obtain our access token to login in our goole account. Paste this token in the CLI and permit the interaction of our agent with our working folder localed in the docker volume:

      ▄▀▀▄
      ▀▀▀▀▀▀
    ▀▀▀▀▀▀▀▀
    ▄▀▀    ▀▀▄
  ▄▀▀      ▀▀▄

  Welcome to the Antigravity CLI. You are currently not signed in.

  Select login method:
  > 1. Google OAuth
    2. Use a Google Cloud project

    ↑/↓ Navigate · enter Select
  ```

  ```shell
      ▄▀▀▄
      ▀▀▀▀▀▀
    ▀▀▀▀▀▀▀▀
    ▄▀▀    ▀▀▄
  ▄▀▀      ▀▀▄

  Your browser should open automatically. If not:

  <GOOGLE_LINK_TO_BE_COPIED_IN_WEB_BROWSER>

  Copy and paste the URL or click on the link below:
  ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  → Click here to authenticate
  ───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

  If you aren't automatically redirected, paste the authorization code below:

  authorization code...

  shift+up/down Navigate
  ```

  ```shell
        ▄▀▀▄        Antigravity CLI 1.5.3
      ▀▀▀▀▀▀       Gemini API key
      ▀▀▀▀▀▀▀▀      Gemini 3.1 Pro (Low)
    ▄▀▀    ▀▀▄     /workspace
    ▄▀▀      ▀▀▄

  ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
  >
  ───────────────────────────
  ```

- Execute our agent container in **auto-pilot** mode. The color theme (dark by default), the license and accept permissions are auto configured:

  ```shell
  docker run --rm -it \
    --cap-drop=ALL --security-opt no-new-privileges \
    -e AGY_AUTOCONFIG=true \
    -e GEMINI_API_KEY=<GEMINI_API_KEY> \
    -v "$PWD":/workspace \
    agy-sandbox agy --dangerously-skip-permissions
  ```
> [!CAUTION]
> In auto-pilot mode, per-token usage with a key is billed through the Gemini API (AI Studio or Google Cloud billing), separately from the subscription

## Code agent sample

  Finally prompt the agent with our simple greeting poc in python. All code generated gy the agent will be inside the working folder poc-greeting, to be started and tested later:

  ```shell
  Start the sample with a prompt like:

        ▄▀▀▄        Antigravity CLI 1.5.3
      ▀▀▀▀▀▀       masalinas.gancedo@gmail.com (Google AI Pro)
      ▀▀▀▀▀▀▀▀      Gemini 4 Argon (Medium)
    ▄▀▀    ▀▀▄     /workspace
    ▄▀▀      ▀▀▄
  ────────────────────────────────────────────────────────────
  > Code a simple fastapi python project using pyproject.toml and implement a greeting endpoint where send a text as string and reponsse like: Hello +
    <string>
  ○ Thought for 20.7s (Considering potential input formats beyond the expected, specifically raw strings or JSON bodies with a "text" key. Preparing t...)
  ● Ran (ls -la /workspace)
  ● Edited 3 files (pyproject.toml, main.py, README.md) (ctrl+o to expand)

    I have created the FastAPI project in /workspace:

    • pyproject.toml — Project configuration with fastapi and uvicorn dependencies.
    • main.py — FastAPI application defining the greeting endpoints:
        • greet_get: GET /greet?text=<string> → "Hello <string>"
        • greet_path: GET /greet/{text} → "Hello <string>"
        • greet_post: POST /greet with JSON {"text": "<string>"} → "Hello <string>"
    • README.md — Quickstart instructions.

    ### How to run

      pip install -e .
      uvicorn main:app --reload

    ### Example usage

      # Query parameter
      curl "http://127.0.0.1:8000/greet?text=World"
      # -> "Hello World"

      # Path parameter
      curl "http://127.0.0.1:8000/greet/World"
      # -> "Hello World"

      # POST JSON payload
      curl -X POST "http://127.0.0.1:8000/greet" \
        -H "Content-Type: application/json" \
        -d '{"text": "World"}'
      # -> "Hello World"
  ```

## Test agent results
The agent create the project inside out volume, so we can create a virtual environment for it, download dependencies and execute the FastAPI server to test with swagger UI accessible:

```shell
python3.12 -m venv .venv
source .venv/bin/activate
pip install -e .
uvicorn main:app --host 0.0.0.0 --port 8001
```

Load swagger UI and test endpoints
```shell
http://localhost:8001/docs
```