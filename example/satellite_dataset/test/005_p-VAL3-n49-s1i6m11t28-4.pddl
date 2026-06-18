(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	spectrograph10 - mode
	image5 - mode
	infrared2 - mode
	infrared1 - mode
	image6 - mode
	image9 - mode
	infrared4 - mode
	spectrograph7 - mode
	image3 - mode
	infrared8 - mode
	thermograph0 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	GroundStation13 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star17 - direction
	Star18 - direction
	Star19 - direction
	GroundStation20 - direction
	Star21 - direction
	GroundStation22 - direction
	GroundStation23 - direction
	Star24 - direction
	Star25 - direction
	GroundStation27 - direction
	Star2 - direction
	Star7 - direction
	GroundStation26 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
	Phenomenon30 - direction
	Star31 - direction
)
(:init
	(supports instrument0 spectrograph7)
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 image9)
	(supports instrument0 image5)
	(supports instrument0 spectrograph10)
	(calibration_target instrument0 Star2)
	(supports instrument1 image6)
	(supports instrument1 infrared8)
	(supports instrument1 infrared4)
	(supports instrument1 infrared1)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation26)
	(calibration_target instrument1 Star7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star21)
)
(:goal (and
	(have_image Phenomenon28 infrared1)
	(have_image Phenomenon28 infrared2)
	(have_image Phenomenon28 spectrograph7)
	(have_image Phenomenon29 image3)
	(have_image Phenomenon29 thermograph0)
	(have_image Phenomenon30 infrared8)
	(have_image Phenomenon30 spectrograph10)
	(have_image Star31 image3)
	(have_image Star31 image5)
))

)
