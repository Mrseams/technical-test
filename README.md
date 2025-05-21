### app version

1.0.2

# DevOps Technical Test: GCP Terraform & PHP Server

This repository demonstrates a DevOps workflow for deploying a PHP application to Google Cloud Platform (GCP) using Terraform. It provisions Cloud SQL, Cloud Storage, and Cloud Run resources, and deploys a containerized PHP server.

## Repository Structure

```
php-server/           # PHP application and Docker setup
  Dockerfile          # Dockerfile for PHP-FPM server
  docker-compose.yml  # Local development setup
  index.php           # Sample PHP entrypoint
  nginx.conf          # Nginx configuration
  supervisord.conf    # Supervisor configuration

terraform/            # Terraform IaC for GCP resources
  main.tf             # Main Terraform configuration
  variables.tf        # Terraform variables
  outputs.tf          # Terraform outputs
  terraform.tfvars    # User-specific variable values
  modules/
    cloud-run/        # Cloud Run module
    cloud-sql/        # Cloud SQL module
    cloud-storage/    # Cloud Storage module

script/
  bash.sh             # Bash script to retrieve Cloud Run public URL
  logs/               # Log files for script runs
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP project with billing enabled
- Service account key with permissions for Cloud Run, Cloud SQL, and Cloud Storage

## Setup Instructions

### 1. Clone the Repository

```powershell
git clone <this-repo-url>
cd <repo-root>
```

### 2. Configure Terraform Variables

Copy the example variables file and edit as needed:

```powershell
Copy-Item terraform/terraform.example.tfvars terraform/terraform.tfvars
```

Edit `terraform/terraform.tfvars` to set your GCP project ID, region, bucket name, container image, and credentials file path. Example:

```hcl
project_id      = "your-gcp-project-id"
region          = "us-central1"
bucket_name     = "your-bucket-name"
container_image = "gcr.io/your-project/your-image:tag"
```

If you need to override the default credentials path, update the `credentials` variable in `terraform/variables.tf` or provide it in your `terraform.tfvars`.

### 3. Build and Push the Docker Image (Optional)

If you want to use your own PHP image:

```powershell
cd php-server
# Build the Docker image
# Replace <your-image-name> as needed
docker build -t <your-gcr-repo>/<your-image-name>:<tag> .
# Push to Google Container Registry or Artifact Registry
docker push <your-gcr-repo>/<your-image-name>:<tag>
```

Update `container_image` in `terraform.tfvars` if you use a custom image.

### 4. Initialize and Apply Terraform

```powershell
cd terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### 5. Accessing the Deployed Application

After `terraform apply` completes, Terraform will output the Cloud Run service URL. Visit this URL in your browser to access the PHP application.

## Running the Bash Script to Retrieve the Public IP Address

A helper script is provided at `script/bash.sh` to retrieve the public URL of your deployed Cloud Run service. To use it:

```powershell
bash script/bash.sh
```

You will be prompted for your GCP Project ID, region, and Cloud Run service name. The script will output the service URL and log the process in `script/cloudrun_lookup.log`.

## Troubleshooting

- **Terraform errors**: Ensure your credentials and project ID are correct, and that required APIs are enabled in your GCP project.
- **Cloud Run URL not found**: Double-check the service name, region, and project ID. Use `gcloud run services list` to verify the service exists.
- **Permission issues**: Make sure your service account has the necessary IAM roles for Cloud Run, Cloud SQL, and Cloud Storage.
- **Windows users**: Use WSL or Git Bash for running bash scripts, or adapt the script for PowerShell if needed.

## Problems Encountered & Solutions

- **API Enablement**: Encountered errors due to missing enabled APIs. Solution: Added `google_project_service` resources in Terraform to enable required APIs automatically.
- **Credential Path Issues**: On Windows, the default credentials path may differ. Solution: Made the credentials path configurable in `variables.tf` and documented the override in setup instructions.
- **Script Compatibility**: Bash script may not run natively on Windows PowerShell. Solution: Recommend using WSL or Git Bash, or adapting the script for PowerShell.

## Additional Features for Production-Ready Environments

- **Monitoring & Logging**: Integrate Stackdriver Monitoring and Logging for observability.
- **Security Configurations**: Implement IAM least privilege, enable VPC Service Controls, and use Secret Manager for sensitive data.
- **CI/CD Pipeline**: Automate build, test, and deployment using GitHub Actions or Cloud Build.
- **Backups & DR**: Set up automated Cloud SQL backups and multi-region storage.
- **Custom Domain & HTTPS**: Map a custom domain to Cloud Run and enforce HTTPS.

## License

This project is for technical demonstration purposes.
