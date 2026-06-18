(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	infrared0 - mode
	spectrograph1 - mode
	infrared2 - mode
	thermograph4 - mode
	image3 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation7 - direction
	Star8 - direction
	Star10 - direction
	Star11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star4 - direction
	GroundStation5 - direction
	GroundStation6 - direction
	Star9 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star9)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star4)
	(supports instrument1 thermograph4)
	(supports instrument1 image3)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation6)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(have_image Planet14 infrared0)
	(have_image Phenomenon15 thermograph4)
	(have_image Planet16 infrared2)
	(have_image Star17 thermograph4)
))

)
