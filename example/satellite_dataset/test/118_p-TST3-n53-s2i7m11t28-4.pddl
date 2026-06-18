(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	spectrograph7 - mode
	infrared4 - mode
	image5 - mode
	thermograph0 - mode
	image9 - mode
	infrared2 - mode
	spectrograph10 - mode
	image3 - mode
	infrared8 - mode
	image6 - mode
	infrared1 - mode
	Star0 - direction
	Star4 - direction
	GroundStation6 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation13 - direction
	Star19 - direction
	Star21 - direction
	GroundStation22 - direction
	GroundStation23 - direction
	Star24 - direction
	Star2 - direction
	Star7 - direction
	GroundStation26 - direction
	Star25 - direction
	Star8 - direction
	GroundStation20 - direction
	Star5 - direction
	GroundStation12 - direction
	GroundStation27 - direction
	GroundStation1 - direction
	Star3 - direction
	Star17 - direction
	Star18 - direction
	GroundStation16 - direction
	GroundStation15 - direction
	Star14 - direction
	Phenomenon28 - direction
	Phenomenon29 - direction
	Phenomenon30 - direction
	Star31 - direction
)
(:init
	(supports instrument0 spectrograph7)
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star2)
	(supports instrument1 image6)
	(supports instrument1 spectrograph10)
	(calibration_target instrument1 GroundStation26)
	(calibration_target instrument1 Star7)
	(supports instrument2 infrared8)
	(supports instrument2 image5)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 GroundStation27)
	(calibration_target instrument2 GroundStation12)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation20)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 Star25)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star21)
	(supports instrument3 image9)
	(supports instrument3 image6)
	(supports instrument3 image3)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph0)
	(supports instrument3 infrared4)
	(calibration_target instrument3 Star14)
	(calibration_target instrument3 GroundStation15)
	(calibration_target instrument3 GroundStation16)
	(calibration_target instrument3 Star18)
	(calibration_target instrument3 Star17)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation27)
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
