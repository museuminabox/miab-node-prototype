express = require "express"
router = express.Router()

api = require "./api"
fake_rfid = require "./fake-rfid"
homepage = require "./homepage"

router.get '/', homepage.index
router.get '/fake-rfid', fake_rfid.index
router.get '/api/miab.tag.detected', api.tag_detect
router.get '/api/miab.tag.lost', api.tag_lost

module.exports = router
