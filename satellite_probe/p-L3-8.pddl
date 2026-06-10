(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	image0 - mode
	thermograph1 - mode
	thermograph2 - mode
	infrared3 - mode
	GroundStation0 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star8 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation16 - direction
	GroundStation17 - direction
	Star19 - direction
	GroundStation1 - direction
	Star15 - direction
	GroundStation10 - direction
	Star7 - direction
	GroundStation5 - direction
	GroundStation9 - direction
	Star18 - direction
	Star4 - direction
	GroundStation14 - direction
	GroundStation11 - direction
	Star6 - direction
	Planet20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Phenomenon24 - direction
	Phenomenon25 - direction
	Star26 - direction
	Phenomenon27 - direction
	Phenomenon28 - direction
	Planet29 - direction
	Planet30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation1)
	(calibration_target instrument0 GroundStation5)
	(supports instrument1 thermograph1)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star7)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star15)
	(supports instrument2 thermograph2)
	(supports instrument2 thermograph1)
	(supports instrument2 image0)
	(calibration_target instrument2 Star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument3 thermograph1)
	(supports instrument3 infrared3)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star6)
	(calibration_target instrument3 GroundStation11)
	(calibration_target instrument3 GroundStation14)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation17)
)
(:goal (and
	(have_image Planet20 thermograph2)
	(have_image Planet21 image0)
	(have_image Phenomenon22 infrared3)
	(have_image Star23 infrared3)
	(have_image Phenomenon24 infrared3)
	(have_image Phenomenon25 image0)
	(have_image Star26 thermograph1)
	(have_image Phenomenon27 image0)
	(have_image Phenomenon28 infrared3)
	(have_image Planet29 infrared3)
	(have_image Planet30 thermograph2)
	(have_image Planet31 thermograph2)
))

)
