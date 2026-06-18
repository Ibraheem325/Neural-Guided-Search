(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	infrared3 - mode
	image5 - mode
	image1 - mode
	infrared6 - mode
	spectrograph4 - mode
	spectrograph0 - mode
	thermograph2 - mode
	Star3 - direction
	Star5 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	GroundStation2 - direction
	GroundStation7 - direction
	Star12 - direction
	GroundStation0 - direction
	Star11 - direction
	Star1 - direction
	Star9 - direction
	Star4 - direction
	GroundStation6 - direction
	Star13 - direction
	Phenomenon14 - direction
	Planet15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared6)
	(calibration_target instrument0 GroundStation0)
	(calibration_target instrument0 Star12)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 GroundStation2)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 thermograph2)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star11)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument3 image1)
	(supports instrument3 thermograph2)
	(supports instrument3 image5)
	(supports instrument3 spectrograph4)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 Star4)
	(calibration_target instrument3 Star9)
	(calibration_target instrument3 Star1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star4)
)
(:goal (and
	(pointing satellite1 Planet15)
	(have_image Star13 spectrograph0)
	(have_image Star13 image5)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon14 spectrograph4)
	(have_image Planet15 spectrograph4)
	(have_image Planet15 infrared3)
	(have_image Phenomenon16 spectrograph4)
))

)
