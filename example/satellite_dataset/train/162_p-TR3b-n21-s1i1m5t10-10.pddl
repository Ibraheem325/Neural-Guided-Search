(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	thermograph4 - mode
	spectrograph2 - mode
	Star0 - direction
	Star1 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation9 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star8 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation4)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star6)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Star10 spectrograph1)
	(have_image Star11 thermograph4)
	(have_image Star12 spectrograph1)
	(have_image Star13 spectrograph0)
))

)
