# Sources

## What is this document?

This lists various sources of joke apis that were investigated for this project.
Each source section provides links, notes, and decision around its use.

## Included Sources

### [JokeAPI](https://sv443.net/jokeapi/v2/)

- Jokes stored in repo, so can support offline if copy the file with credit listed.
- Supports "safe mode".
- Supports multiple languages.
- Supports filtering random joke.
- Get up to 10 jokes.
  - Get in id range and uses int as id, so couple probably do pagination if needed.
- License compatible with own.

Decision: Include

### [Official Joke API](https://github.com/15Dkatz/official_joke_api)

- Jokes stored in repo, so can support offline if copy the file with credit listed.
- Only random get.
- Get by type from "general", "knock-knock", "programming", and "dad".
- Get any number of jokes at once.
  - If get more than total then get error "The passed path exceeds the number of jokes (451)."
- License compatible with own.

Decision: Include

## Not Included Sources

### [icanhazdadjoke](https://icanhazdadjoke.com/api)

- Supports random joke and pagination to get all.
- Seems closed source, only repos I could find are third party wrappers. Found GitHub profiles of author and organisation but could not see this repo in their list.  
- License is personal use only: <https://icanhazdadjoke.com/tos>

Decision: Not to be used due the license not being compatible with the MIT open license of this project and allows commercial use. 

### [API Ninjas Jokes API](https://www.api-ninjas.com/api/jokes)

- Get one joke for free.
- Need premium to get more than one at a time.
- Doesn't really seem meant for our use.
- Only for commercial use if pay.

Decision: Not to be used, too restrictive unless we pay.

### [Humor API](https://humorapi.com)

- Costs money for reasonable use.

Decision: Business model not compatible.
