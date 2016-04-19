express = require "express"
router = express.Router()
multer = require "multer"

api = require "./api"
fake_rfid = require "./fake-rfid"
homepage = require "./homepage"

router.get '/', homepage.index
router.post '/', multer(dest: './uploads/').single('upl'), homepage.save_tag
router.get '/fake-rfid', fake_rfid.index
router.get '/api/miab.tag.detected', api.tag_detect
router.get '/api/miab.tag.lost', api.tag_lost

module.exports = router
