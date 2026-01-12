# Argflow Presets

Bundled presets for argflow. Each preset contains language-agnostic classifications and language-specific mappings for detecting and classifying function calls.

## Available Presets

| Preset   | Description                           |
| -------- | ------------------------------------- |
| `crypto` | Cryptographic API argument extraction |

## Usage

```bash
# Use a bundled preset
argflow --path ./project --preset crypto

# Combine with custom rules
argflow --path ./project --preset crypto --rules ./my-rules.yaml
```

## Preset Structure

Each preset directory contains:

```
presets/<name>/
├── preset.yaml    # Metadata (name, version, description, languages)
└── rules.yaml     # Classifications and language-specific mappings
```

## Rules File Format

The `rules.yaml` file follows this structure:

```yaml
version: "1.0"

classifications:
  pbkdf2_key:
    algorithm: PBKDF2
    algorithmFamily: PBKDF2
    findingType: kdf
    operation: keyderive
    primitive: kdf

languages:
  go:
    mappings:
      golang.org/x/crypto/pbkdf2:
        Key: pbkdf2_key
    structs:
      crypto/tls.Config:
        MinVersion: tls_min_version
    constants:
      crypto/tls:
        VersionTLS12:
          value: 771
          protocol: TLS
          version: "1.2"

  python:
    mappings:
      hashlib:
        pbkdf2_hmac: pbkdf2_key

  rust:
    mappings:
      ring::pbkdf2:
        derive: pbkdf2_key

  javascript:
    mappings:
      crypto:
        pbkdf2: pbkdf2_key
```

## Classification Fields

| Field                      | Required | Description                                                   |
| -------------------------- | -------- | ------------------------------------------------------------- |
| `findingType`              | Yes      | Category: kdf, hash, cipher, aead, signature, etc.            |
| `operation`                | Yes      | Action: keyderive, hash, encrypt, decrypt, sign, verify, etc. |
| `algorithm`                | No       | Algorithm name: PBKDF2, SHA-256, AES-GCM, etc.                |
| `algorithmFamily`          | No       | Algorithm family: SHA-2, AES, RSA, etc.                       |
| `primitive`                | No       | Cryptographic primitive type                                  |
| `mode`                     | No       | Cipher mode: GCM, CBC, CTR, etc.                              |
| `keySize`                  | No       | Key size in bits                                              |
| `curve`                    | No       | Elliptic curve: P256, P384, Ed25519, etc.                     |
| `classicalSecurityLevel`   | No       | Classical security level in bits                              |
| `nistQuantumSecurityLevel` | No       | NIST quantum security level (1-5)                             |

## Language-Specific Features

| Feature     | Go  | Rust | Python | JavaScript |
| ----------- | :-: | :--: | :----: | :--------: |
| `mappings`  | Yes | Yes  |  Yes   |    Yes     |
| `structs`   | Yes | Yes  |   No   |     No     |
| `constants` | Yes | Yes  |   No   |     No     |

## Custom Rules

Users can create their own rules files that extend bundled presets:

```yaml
# my-rules.yaml
version: "1.0"
extends:
  - crypto # Inherit from bundled preset

classifications:
  my_custom_kdf:
    algorithm: CustomKDF
    findingType: kdf
    operation: keyderive

languages:
  go:
    mappings:
      github.com/myorg/crypto:
        DeriveKey: my_custom_kdf
```

Use with:

```bash
argflow --path ./project --rules ./my-rules.yaml
```

## Schema Validation

For editor autocompletion and validation, reference the JSON Schema:

```yaml
# yaml-language-server: $schema=./rules.schema.json
version: "1.0"
# ...
```
