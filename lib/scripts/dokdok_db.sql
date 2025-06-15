--
-- File generated with SQLiteStudio v3.4.17 on Sun Jun 15 18:15:39 2025
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: ProgramLanguage
DROP TABLE IF EXISTS ProgramLanguage;

CREATE TABLE IF NOT EXISTS ProgramLanguage (
    language_id   INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT
                          UNIQUE
                          NOT NULL,
    language_name TEXT    NOT NULL
);

INSERT INTO ProgramLanguage (
                                language_id,
                                language_name
                            )
                            VALUES (
                                1,
                                'Java'
                            );

INSERT INTO ProgramLanguage (
                                language_id,
                                language_name
                            )
                            VALUES (
                                2,
                                'Nodejs'
                            );

INSERT INTO ProgramLanguage (
                                language_id,
                                language_name
                            )
                            VALUES (
                                3,
                                'C#'
                            );

INSERT INTO ProgramLanguage (
                                language_id,
                                language_name
                            )
                            VALUES (
                                4,
                                'Go'
                            );


-- Table: Template
DROP TABLE IF EXISTS Template;

CREATE TABLE IF NOT EXISTS Template (
    template_id INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT
                        NOT NULL
                        UNIQUE,
    code        TEXT,
    program_id  INTEGER CONSTRAINT fk_languange_id REFERENCES ProgramLanguage (language_id) ON DELETE CASCADE
                                                                                            ON UPDATE CASCADE
                        NOT NULL
);

INSERT INTO Template (
                         template_id,
                         code,
                         program_id
                     )
                     VALUES (
                         1,
                         '# Use official OpenJDK base image
FROM eclipse-temurin:17-jdk-jammy

# Set working directory
WORKDIR /app

# Copy build files (adjust for your build tool)
COPY build.gradle .
COPY src ./src

# Build the application (Gradle example)
RUN ./gradlew build

# Run the application
CMD ["java", "-jar", "build/libs/your-app.jar"]',
                         1
                     );

INSERT INTO Template (
                         template_id,
                         code,
                         program_id
                     )
                     VALUES (
                         2,
                         '# Use official Node.js LTS image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY . .

# Build (if needed)
RUN npm run build

# Run the application
CMD ["npm", "start"]',
                         2
                     );

INSERT INTO Template (
                         template_id,
                         code,
                         program_id
                     )
                     VALUES (
                         3,
                         '# Use official .NET SDK to build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "YourApp.dll"]',
                         3
                     );

INSERT INTO Template (
                         template_id,
                         code,
                         program_id
                     )
                     VALUES (
                         4,
                         '# Build stage
FROM golang:1.20-alpine AS build
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /app/main .

# Run stage
FROM alpine:latest
WORKDIR /app
COPY --from=build /app/main .
CMD ["./main"]',
                         4
                     );


-- Table: User
DROP TABLE IF EXISTS User;

CREATE TABLE IF NOT EXISTS User (
    user_id    INTEGER PRIMARY KEY ON CONFLICT ROLLBACK AUTOINCREMENT
                       UNIQUE
                       NOT NULL,
    first_name TEXT,
    last_name  TEXT,
    password   TEXT    NOT NULL
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
