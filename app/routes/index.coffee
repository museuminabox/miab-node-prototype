express = require "express"
router = express.Router()

homepage = require "./homepage"

router.get '/', homepage.index

module.exports = router
