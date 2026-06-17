(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	spectrograph2 - mode
	image0 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	Star11 - direction
	Phenomenon12 - direction
	Planet13 - direction
	Planet14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 image0)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation5)
)
(:goal (and
	(have_image Phenomenon12 thermograph1)
	(have_image Planet13 thermograph1)
	(have_image Planet14 spectrograph2)
	(have_image Star15 thermograph1)
))

)
