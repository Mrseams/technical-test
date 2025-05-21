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
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP project with billing enabled
- Service account key with permissions for Cloud Run, Cloud SQL, and Cloud Storage

## Setup Instructions

### 1. Clone the Repository

```sh
git clone <this-repo-url>
cd <repo-root>
```

### 2. Configure Terraform Variables

Copy the example variables file and edit as needed:

```sh
cp terraform/terraform.example.tfvars terraform/terraform.tfvars
```

Edit `terraform/terraform.tfvars` to set your GCP project ID, region, bucket name, container image, and credentials file path.

### 3. Build and Push the Docker Image (Optional)

If you want to use your own PHP image:

```sh
cd php-server
# Build the Docker image
# Replace <your-image-name> as needed
docker build -t <your-gcr-repo>/<your-image-name>:<tag> .
# Push to Google Container Registry or Artifact Registry
docker push <your-gcr-repo>/<your-image-name>:<tag>
```

Update `container_image` in `terraform.tfvars` if you use a custom image.

### 4. Initialize and Apply Terraform

```sh
cd terraform
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### 5. Accessing the Deployed Service

After `terraform apply` completes, Terraform will output the Cloud Run service URL. Visit this URL in your browser to access the PHP application.

## Notes

- The Terraform configuration enables required GCP APIs and provisions all resources in the specified region.
- The Cloud Run service is deployed using the container image specified in `terraform.tfvars`.
- Cloud SQL and Cloud Storage modules are included for database and file storage needs.

## Cleanup

To remove all resources created by Terraform:

```sh
cd terraform
terraform destroy -var-file="terraform.tfvars"
```

## License

This project is for technical demonstration purposes.
