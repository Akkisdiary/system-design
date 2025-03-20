# Text Storage Service (Pastebin)

## Functional Requirements
- Users are able to save text content and get a shareable url
- Users can access the saved text content using the url
- Text content size is limited to 10MB

## Non-Functional Requirements
- High availability (the service should be up 99.9% of the time)
- Low latency (user should get the content in milli seconds)
- Scalability (the system should handle millions of requests per day)
- Durability (saved content should work for years)

## Design
![architecture](./diagrams/architecture.png)
- LB - Load Balancer distributing requests across API servers
- API Servers - Backend application servers handling create and read requests
- Key Gen Service - Generates unique keys for creating the unique url. Uses Cache 2 to keep track of used and unused keys
- DB - Stores short url to original url mapping. Since the database needs high throughput to handle large number of reads as compared to writes and don't require joins between tables - A NoSQL DB like **Cassandra** is a good choice
- Cache 1 - Stores frequently accessed texts
- Cache 2 - Distributed cached which stores used and unused keys
- S3 - Storage for large text content

## Database schema
![db-schema](./diagrams/db-schema.png)

## Capacity estimation
- Daily create requests: 1 Million 
- Assuming 10:1 read write ratio
- Daily read requests: 10 Million
- Avg text size: 100 KB
- Peak load: 10x the average

#### Throughput
Avg writes per second: 1M / (60 * 60 * 24) = 12
Avg reads per second: 12 * 10 = 120
Peak RPS: 1200

#### Storage
- Text content per day: 1M * 100KB =~ 100GB (assuming 100KB text size avg)
- Per year = 3.7TB

## Highlights
- When the text size is greater than some pre-defined value (say 100KB) then the text is stored in S3 and a link to the S3 file is store in DB. A small portion of the text also stored in the DB (first 100 KB) to show a preview of the text to the user. The front end application can then fetch the complete file using the S3 url