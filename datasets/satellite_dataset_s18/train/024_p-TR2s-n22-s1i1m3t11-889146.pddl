(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph0 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	Star4 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph0)
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
)
(:goal (and
	(pointing satellite0 GroundStation3)
	(have_image Star11 spectrograph1)
	(have_image Star12 spectrograph1)
	(have_image Star13 spectrograph2)
	(have_image Phenomenon14 spectrograph1)
	(have_image Phenomenon15 thermograph0)
	(have_image Phenomenon16 spectrograph1)
))

)
