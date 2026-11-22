const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    message: 'Safe Campus backend starter is running',
  });
});

app.use((req, res) => {
  res.status(404).json({
    message: 'Route not found',
  });
});

module.exports = app;