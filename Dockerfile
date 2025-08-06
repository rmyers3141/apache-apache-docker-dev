# Use official Apache httpd image:
FROM httpd:2.4

# Copy my SSL and reverse-proxy configuration:
COPY ./config/* /usr/local/apache2/conf/


