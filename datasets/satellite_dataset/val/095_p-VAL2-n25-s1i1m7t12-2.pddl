(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	infrared2 - mode
	spectrograph0 - mode
	image5 - mode
	thermograph1 - mode
	spectrograph6 - mode
	image4 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	Star11 - direction
	GroundStation6 - direction
	Star2 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(supports instrument0 image4)
	(supports instrument0 spectrograph6)
	(supports instrument0 image5)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star7)
)
(:goal (and
	(pointing satellite0 GroundStation9)
	(have_image Planet12 infrared2)
	(have_image Planet13 thermograph1)
	(have_image Star14 spectrograph6)
	(have_image Star15 spectrograph0)
))

)
