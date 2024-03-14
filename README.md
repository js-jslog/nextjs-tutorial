## Next.js App Router Course - Starter

This is the starter template for the Next.js App Router Course. It contains the starting code for the dashboard application.

For more information, see the [course curriculum](https://nextjs.org/learn) on the Next.js Website.

## Build and run docker container

```bash
docker build -t nextjs-dashboard-image .
docker run -e POSTGRES_URL="postgres://default:<password>@ep-bold-credit-a4s6qon8-pooler.us-east-1.aws.neon.tech:5432/verceldb?sslmode=require" -p 3000:3000 --name nextjs-dashboard-container -v nextjs-dashboard-volume:/app nextjs-dashboard-image
```

> Substitute `<password>` with the password for the database.
