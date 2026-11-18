(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image0 - mode
	image3 - mode
	spectrograph2 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star8 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	GroundStation14 - direction
	GroundStation15 - direction
	Star9 - direction
	Star16 - direction
	Phenomenon17 - direction
	Planet18 - direction
	Planet19 - direction
	Star20 - direction
	Planet21 - direction
	Planet22 - direction
	Planet23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Planet26 - direction
	Phenomenon27 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
	Phenomenon30 - direction
	Planet31 - direction
	Star32 - direction
	Phenomenon33 - direction
	Phenomenon34 - direction
	Phenomenon35 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 spectrograph1)
	(supports instrument0 spectrograph2)
	(supports instrument0 image3)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon27)
)
(:goal (and
	(have_image Star16 spectrograph1)
	(have_image Phenomenon17 spectrograph2)
	(have_image Planet18 spectrograph1)
	(have_image Planet19 image0)
	(have_image Star20 spectrograph1)
	(have_image Planet21 image0)
	(have_image Planet22 spectrograph1)
	(have_image Planet23 image3)
	(have_image Star24 image3)
	(have_image Phenomenon25 image0)
	(have_image Planet26 image0)
	(have_image Phenomenon27 spectrograph2)
	(have_image Phenomenon28 spectrograph1)
	(have_image Phenomenon29 image3)
	(have_image Phenomenon30 spectrograph1)
	(have_image Planet31 spectrograph2)
	(have_image Star32 spectrograph1)
	(have_image Phenomenon33 spectrograph2)
	(have_image Phenomenon34 image0)
	(have_image Phenomenon35 image3)
))

)
