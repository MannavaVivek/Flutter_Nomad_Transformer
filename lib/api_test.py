from contentful import Client
client = Client(
  'pqzjijb5vjqz',
  'IVqE-SRtoM5IZ8bTHuf0Cwnx3Jb470uML77gX-2mYwQ',
  environment='master'  # Optional - it defaults to 'master'.
)

# locales = client.assets()
# for locale in locales.items:
#   print(locale.fields())
entries = client.entries({'metadata.tags.sys.id[all]': 'city'})
for entry in entries:
  print(entry.fields())
  print(entry._metadata['tags'])