# Stage 1: Build the Go binary
FROM golang:1.22-alpine AS builder

WORKDIR /app

# Copy go.mod first and download dependencies
COPY go.mod ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go binary
RUN go build -o main .

# Stage 2: Use a lightweight runtime image
FROM gcr.io/distroless/base

WORKDIR /app

# Copy binary and static files from builder stage
COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080

CMD ["./main"]