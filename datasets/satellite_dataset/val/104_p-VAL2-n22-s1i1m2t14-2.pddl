(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star7 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation6 - direction
	GroundStation9 - direction
	GroundStation8 - direction
	Star10 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(pointing satellite0 Star13)
	(have_image Star14 thermograph1)
	(have_image Planet15 spectrograph0)
	(have_image Star16 spectrograph0)
	(have_image Planet17 spectrograph0)
))

)
