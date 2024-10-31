# Используем Node.js как базовый образ для сборки
FROM node:18 AS build

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файлы package.json и package-lock.json в контейнер
COPY package*.json ./

# Устанавливаем зависимости для сервера и Prisma
RUN npm install

# Копируем весь код проекта в контейнер
COPY . .

# Генерируем Prisma клиент
RUN npx prisma generate

# Устанавливаем зависимости и создаем сборку для клиентской части
RUN npm install --prefix client && npm run build --prefix client

# Удаляем devDependencies, чтобы уменьшить размер конечного контейнера
RUN npm prune --production

# Настройка переменной окружения для порта (Render автоматически установит PORT)
ENV PORT=3000

# Указываем, какой порт должен быть открыт
EXPOSE 3000

# Запускаем серверное приложение
CMD ["npm", "start"]
