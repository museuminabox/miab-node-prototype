express = require "express"
router = express.Router()

api = require "./api"
homepage = require "./homepage"

router.get '/', homepage.index
router.get '/api/miab.tag.detected', api.tag_detect
router.get '/api/miab.tag.lost', api.tag_lost

module.exports = router
