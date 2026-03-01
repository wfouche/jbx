import std/[httpclient, json]

# 1. Initialize the client
let client = newHttpClient()

try:
  # 2. Retrieve the content
  let url = "https://raw.githubusercontent.com/jbangdev/jbang-catalog/refs/heads/main/jbang-catalog.json"
  let response = client.getContent(url)

  # 3. Parse the JSON string
  let data = parseJson(response)

  # 4. Access fields
  let scriptRef = data["aliases"]["jbang-fmt"]["script-ref"].getStr()

  echo "script-ref for jbang-fmt is ", scriptRef

finally:
  client.close()