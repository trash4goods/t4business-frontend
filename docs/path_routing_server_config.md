# Flutter Web Path-Based Routing Server Configurations

## Apache (.htaccess)
```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.html [QSA,L]
```

## Nginx
```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

## Firebase Hosting (firebase.json)
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

## AWS S3 with CloudFront
- Configure CloudFront to redirect 404 errors to `/index.html`
- Set error page path: `/index.html`
- Set HTTP response code: 200

## Netlify (_redirects file)
```
/*    /index.html   200
```

## Vercel (vercel.json)
```json
{
  "rewrites": [
    {
      "source": "/(.*)",
      "destination": "/index.html"
    }
  ]
}
```

## GitHub Pages
GitHub Pages doesn't support server-side redirects, so you'll need to:
1. Use hash-based routing (keep the "#")
2. Or use a 404.html workaround to simulate redirects
