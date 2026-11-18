(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	image0 - mode
	infrared3 - mode
	spectrograph1 - mode
	thermograph4 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	Star6 - direction
	GroundStation5 - direction
	Star3 - direction
	Planet7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(supports instrument0 image0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation5)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(have_image Planet7 thermograph2)
	(have_image Star8 thermograph4)
	(have_image Star9 thermograph4)
	(have_image Star10 infrared3)
	(have_image Phenomenon11 infrared3)
	(have_image Phenomenon12 image0)
	(have_image Planet13 infrared3)
))

)
