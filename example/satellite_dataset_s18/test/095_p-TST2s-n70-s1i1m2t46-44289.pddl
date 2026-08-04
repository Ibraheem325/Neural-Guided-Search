(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	image0 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	GroundStation12 - direction
	Star13 - direction
	Star14 - direction
	Star15 - direction
	Star16 - direction
	Star17 - direction
	Star18 - direction
	Star19 - direction
	Star20 - direction
	Star21 - direction
	GroundStation22 - direction
	Star23 - direction
	GroundStation24 - direction
	GroundStation26 - direction
	Star27 - direction
	GroundStation28 - direction
	Star29 - direction
	GroundStation30 - direction
	GroundStation31 - direction
	Star32 - direction
	GroundStation33 - direction
	Star34 - direction
	GroundStation35 - direction
	GroundStation36 - direction
	Star37 - direction
	Star38 - direction
	GroundStation39 - direction
	Star40 - direction
	Star41 - direction
	Star42 - direction
	Star43 - direction
	Star44 - direction
	Star45 - direction
	GroundStation0 - direction
	Star25 - direction
	Star46 - direction
	Phenomenon47 - direction
	Phenomenon48 - direction
	Planet49 - direction
	Star50 - direction
	Star51 - direction
	Planet52 - direction
	Star53 - direction
	Planet54 - direction
	Phenomenon55 - direction
	Star56 - direction
	Star57 - direction
	Star58 - direction
	Phenomenon59 - direction
	Star60 - direction
	Phenomenon61 - direction
	Planet62 - direction
	Star63 - direction
	Planet64 - direction
	Planet65 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 image0)
	(calibration_target instrument0 Star25)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star57)
)
(:goal (and
	(have_image Star46 image0)
	(have_image Phenomenon47 spectrograph1)
	(have_image Phenomenon48 spectrograph1)
	(have_image Planet49 image0)
	(have_image Star50 spectrograph1)
	(have_image Star51 spectrograph1)
	(have_image Planet52 image0)
	(have_image Star53 spectrograph1)
	(have_image Planet54 image0)
	(have_image Phenomenon55 image0)
	(have_image Star56 spectrograph1)
	(have_image Star57 image0)
	(have_image Star58 spectrograph1)
	(have_image Phenomenon59 spectrograph1)
	(have_image Star60 image0)
	(have_image Phenomenon61 image0)
	(have_image Planet62 spectrograph1)
	(have_image Star63 image0)
	(have_image Planet64 image0)
	(have_image Planet65 image0)
))

)
