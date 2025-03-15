# URL Shortener

## Requirements

#### Functional
1. Generate a unique short URL for a given long URL
2. Redirect the user to the original URL when the short URL is accessed
4. Support link expiration where URLs are no longer accessible after a certain period
3. Allow users to customize their short URLs (optional)
5. Provide analytics on link usage (optional)

#### Non-Functional
1. High availability (the service should be up 99.9% of the time)
2. Low latency (url shortening and redirects should happen in milliseconds)
3. Scalability (the system should handle millions of requests per day)
4. Durability (shortened URLs should work for years)
5. Security to prevent malicious use, such as phishing.

## Capacity estimation
- Daily shorten url requests: 1 million
- Read/Write ratio: 100:1 (100 redirects for 1 shortened url per day)
- Peak load: 10x the avg
- Avg original url length: 100 characters

#### Throughput
- Avg writes per second: 1,000,000 / (60 * 60 * 24) ~ 12
- Peak WPS: 12 * 10 = 120
- Avg redirects: 12 * 100 = 1,200
- Peak RPS: 1200 * 10 = 12,000

#### Storage
- Short URL: 7 bytes (assuming 7 characters in short url)
- Original URL: 100 bytes
- Creation date: 8 bytes (timestamp)
- Expiration date: 8 bytes (timestamp)
- Click count: 4 bytes

Total Storage per url
- **7 + 100 + 8 + 8 + 4 = 127**

Total storage per Year: 
- **1M * 127 * 360 = 43.2 GB**

## Design

![architecture](./diagrams/architecture.svg)

## Database schema

![db-schema](./diagrams/db-schema.svg)
