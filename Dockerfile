# Use the official Nginx image as a base image
FROM nginx:stable-alpine

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Copy the application content to the Nginx HTML directory
COPY . /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
