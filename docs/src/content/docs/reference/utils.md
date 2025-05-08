---
title: "Utilities"
description: "Helper modules for file uploads and AWS S3 form uploads."
---

## Utils.FileUpload

Resizes and saves uploaded images locally.

```elixir
Utils.FileUpload.upload(:presentation, "/tmp/upload.png", "/uploads/presentation/old.png")
# => "/uploads/presentation/upload.png"
```

- Uses Mogrify to `resize_to_fill("100x100")`.
- Copies file into `priv/static/uploads/<type>/`.

## SimpleS3Upload

Generates a signed form policy for direct S3 uploads (SigV4 POST).

```elixir
config = %{
  region: "us-east-1",
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")
}

{:ok, fields} =
  SimpleS3Upload.sign_form_upload(config, "my-bucket",
    key: "public/my-file.png",
    content_type: "image/png",
    max_file_size: 5_000_000,
    expires_in: :timer.hours(1)
  )
```

- Returns `fields` map for JavaScript `FormData`.
- Supports `x-amz-server-side-encryption: AES256`.