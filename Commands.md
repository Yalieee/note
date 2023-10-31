# Set all sub-directory permission
find /test -type d -exec chmod 777 {} +

# Clean files older than 7 days
find /test/ -mindepth 1 -mtime +7 -delete
