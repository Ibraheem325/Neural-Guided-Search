(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	image1 - mode
	image5 - mode
	spectrograph4 - mode
	thermograph2 - mode
	infrared3 - mode
	infrared6 - mode
	spectrograph0 - mode
	Star4 - direction
	Star5 - direction
	GroundStation8 - direction
	Star11 - direction
	Star12 - direction
	GroundStation6 - direction
	Star9 - direction
	Star13 - direction
	GroundStation7 - direction
	GroundStation2 - direction
	GroundStation0 - direction
	Star3 - direction
	GroundStation10 - direction
	Star1 - direction
	Phenomenon14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star9)
	(supports instrument1 infrared3)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 spectrograph0)
	(supports instrument2 infrared6)
	(supports instrument2 image1)
	(calibration_target instrument2 Star13)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 Star9)
	(supports instrument3 image5)
	(calibration_target instrument3 GroundStation0)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation7)
	(supports instrument4 spectrograph0)
	(supports instrument4 spectrograph4)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 GroundStation10)
	(calibration_target instrument4 Star3)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(on_board instrument4 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
)
(:goal (and
	(have_image Phenomenon14 infrared6)
	(have_image Phenomenon14 spectrograph0)
	(have_image Star15 image1)
	(have_image Phenomenon16 spectrograph0)
	(have_image Phenomenon17 infrared6)
))

)
