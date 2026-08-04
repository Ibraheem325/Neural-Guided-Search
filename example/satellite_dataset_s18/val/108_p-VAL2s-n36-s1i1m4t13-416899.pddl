(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	image1 - mode
	spectrograph3 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	GroundStation4 - direction
	GroundStation12 - direction
	GroundStation2 - direction
	Planet13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Star17 - direction
	Star18 - direction
	Planet19 - direction
	Star20 - direction
	Phenomenon21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Planet26 - direction
	Phenomenon27 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph3)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation12)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon21)
)
(:goal (and
	(pointing satellite0 Phenomenon22)
	(have_image Planet13 infrared2)
	(have_image Star14 spectrograph3)
	(have_image Phenomenon15 infrared2)
	(have_image Star16 spectrograph0)
	(have_image Star17 infrared2)
	(have_image Star18 spectrograph3)
	(have_image Planet19 image1)
	(have_image Star20 spectrograph0)
	(have_image Phenomenon21 spectrograph3)
	(have_image Phenomenon22 spectrograph3)
	(have_image Star23 image1)
	(have_image Star24 image1)
	(have_image Phenomenon25 spectrograph0)
	(have_image Planet26 spectrograph0)
	(have_image Phenomenon27 spectrograph0)
	(have_image Phenomenon28 image1)
	(have_image Phenomenon29 spectrograph0)
))

)
