import { PrismaClient } from '@prisma/client'
import express from 'express'
import { convertExpectedNumber, convertExpectedString } from './helper'

const prisma = new PrismaClient()
const app = express()
const cors = require('cors')

app.use(express.json())
app.use(cors())

// READ Positions with all tags
app.get('/positions', async (req, res) => {
  const positions = await prisma.position.findMany({
    include: { tags: true }
  })
  res.json(positions)
})

// READ Position with all tags
app.get('/positions/:id', async (req, res) => {
  const { id } = req.params
  const position = await prisma.position.findUnique({
    where: { id: Number(id) },
    include: { tags: true }
  })
  res.json(position)
})

// CREATE Position
app.post('/position/new', async (req, res) => {
  const { name, price_rub, description, weight_g, volume_ml, ingredients, tags } = req.body
  const result = await prisma.position.create({
    data: {
      name,
      price_rub: Number(price_rub),
      description: description ? description : null,
      weight_g: weight_g ? Number(weight_g) : null,
      volume_ml: volume_ml ? Number(volume_ml) : null,
      ingredients: ingredients ? ingredients : null,
      tags: {
        connect: tags
      }
    },
    include: {
      tags: true
    }
  })
  res.json(result)
})

// UPDATE Position
app.put('/positions/:id', async (req, res) => {
  const { id } = req.params
  const { name, description, ingredients, weight_g, volume_ml, price_rub, tags } = req.body

  const result = await prisma.position.update({
    where: { id: Number(id) },
    data: {
      name: name ? name : undefined,
      description: convertExpectedString(description),
      ingredients: convertExpectedString(ingredients),
      weight_g: convertExpectedNumber(weight_g),
      volume_ml: convertExpectedNumber(volume_ml),
      price_rub: price_rub ? Number(price_rub) : undefined,
      tags: {
        connect: tags?.added ? tags.added : [],
        disconnect: tags?.removed ? tags.removed : []
      }
    },
    include: {
      tags: true
    }
  })
  res.json(result)
})

// DELETE Position
app.delete('/positions/:id', async (req, res) => {
  const { id } = req.params
  const result = await prisma.position.delete({
    where: { id: Number(id) }
  })
  res.json(result)
})

// READ Categories with all values(tags)
app.get('/categories', async (req, res) => {
  const categories = await prisma.category.findMany({
    include: { tags: true }
  })
  res.json(categories)
})

// CREATE Category with any tags
app.post('/category/new', async (req, res) => {
  // values: CategoryVal[]
  const { name, description } = req.body
  const tags = []
  for (let tag in req.body.tags) {
    tags.push({ value: req.body.tags[tag] })
  }
  const result = await prisma.category.create({
    data: {
      name,
      description,
      tags: {
        create: tags
      }
    },
  })
  res.json(result)
})

// READ Category with all tags
app.get('/category/:id', async (req, res) => {
  const { id } = req.params
  const result = await prisma.category.findUnique({
    where: { id: Number(id) },
    include: {
      tags: {
        select: {
          value: true
        }
      }
    }
  })
  res.json(result)
})

// UPDATE Category (and related tags)
app.put('/category/:id', async (req, res) => {
  const { id } = req.params
  const { name, description, tags } = req.body

  const result = await prisma.category.update({
    where: { id: Number(id) },
    data: {
      name,
      description,
      tags: {
        createMany: {
          data: tags.new
        },
        deleteMany: tags.deleted
      }
    }
  })
  res.json(result)
})

// DELETE Category with all related tags
app.delete('/category/:id', async (req, res) => {
  const { id } = req.params
  const deletedCategoryTags = await prisma.tag.deleteMany({
    where: { categoryId: Number(id) }
  })
  const result = await prisma.category.delete({
    where: { id: Number(id) }
  })
  res.json({
    categoryTags: deletedCategoryTags,
    category: result
  })
})

app.listen(3000, () => {
  console.log('REST API server ready at http://localhost:3000')
})