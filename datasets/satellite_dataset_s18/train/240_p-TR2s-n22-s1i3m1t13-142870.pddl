(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star10 - direction
	Star12 - direction
	Star4 - direction
	Star8 - direction
	GroundStation5 - direction
	Star11 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Phenomenon17 - direction
	Star18 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon15)
)
(:goal (and
	(have_image Planet13 spectrograph0)
	(have_image Phenomenon14 spectrograph0)
	(have_image Phenomenon15 spectrograph0)
	(have_image Star16 spectrograph0)
	(have_image Phenomenon17 spectrograph0)
	(have_image Star18 spectrograph0)
))

)
