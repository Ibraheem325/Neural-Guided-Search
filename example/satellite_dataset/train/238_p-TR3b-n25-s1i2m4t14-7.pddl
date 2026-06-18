(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared3 - mode
	spectrograph2 - mode
	image0 - mode
	thermograph1 - mode
	Star0 - direction
	Star1 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	Star3 - direction
	Star10 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star13)
	(supports instrument1 image0)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
)
(:goal (and
	(pointing satellite0 Star10)
	(have_image Planet14 thermograph1)
	(have_image Phenomenon15 image0)
	(have_image Planet16 thermograph1)
	(have_image Planet17 image0)
))

)
