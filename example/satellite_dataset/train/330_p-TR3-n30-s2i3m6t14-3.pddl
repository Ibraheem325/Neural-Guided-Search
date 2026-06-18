(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared5 - mode
	image2 - mode
	image4 - mode
	infrared1 - mode
	image3 - mode
	spectrograph0 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation7 - direction
	Star5 - direction
	Star3 - direction
	GroundStation6 - direction
	Star14 - direction
	Planet15 - direction
	Star16 - direction
	Phenomenon17 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image3)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument1 image4)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph0)
	(supports instrument1 infrared5)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 infrared1)
	(supports instrument2 image2)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star5)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation10)
)
(:goal (and
	(have_image Star14 spectrograph0)
	(have_image Star14 image3)
	(have_image Planet15 infrared5)
	(have_image Star16 spectrograph0)
	(have_image Phenomenon17 spectrograph0)
))

)
