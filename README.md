# Crypto Classifier Rules

Cryptographic function classification rules for crypto extractor tools. Contains language-agnostic classifications and language-specific mappings.

## Structure

```
crypto-classifier-rules/
├── classifications.json    # Shared: lookup key -> standardized metadata (algorithm/findingType/operation)
├── go/mappings.json        # Go: package.function -> lookup key (bridges Go APIs to shared metadata)
├── rust/mappings.json      # Rust: module::function -> lookup key (bridges Rust APIs to shared metadata)
├── python/mappings.json    # Python: module.function -> lookup key (bridges Python APIs to shared metadata)
└── javascript/mappings.json # JavaScript: module.function -> lookup key (bridges JS APIs to shared metadata)
```

## How It Works

1. **Language-Specific Mappings**: Each language maps its crypto API calls to lookup keys (e.g., `crypto/pbkdf2.Key` → `pbkdf2_key`)
2. **Shared Classifications**: All languages use the same lookup keys mapped to classifications (e.g., `pbkdf2_key` → `{"algorithm": "PBKDF2", "findingType": "kdf", "operation": "keyderive"}`)

## Branching Strategy

This repository uses language-specific branches for clean submodule integration. The `main` branch contains all language mappings (source of truth), while language-specific branches (e.g., `go-v1.0.0`) contain only that language's files plus `classifications.json`.

### Using in Language Projects

Add as a submodule pointing to the language-specific branch:

```bash
git submodule add -b go-v1.0.0 <repo-url> classifier-rules
cd classifier-rules
git checkout go/v1.0.0  # Pin to specific tag
```

### Creating Language Branches

Use the script: `./scripts/create-language-branch.sh <lang> <version>` (e.g., `./scripts/create-language-branch.sh go v1.0.0`)

## Workflow

1. Update `main` branch with new classifications or mappings
2. Create language branch: `./scripts/create-language-branch.sh <lang> <version>`
3. Push branch and tag: `git push origin <lang>-v<version> && git push origin <lang>/v<version>`
4. Language projects update their submodules to the new tag

## Versioning

- **Classifications**: Versioned in `classifications.json`
- **Language Mappings**: Versioned per language branch
- **Tags**: Format `<language>/v<version>` (e.g., `go/v1.0.0`)
