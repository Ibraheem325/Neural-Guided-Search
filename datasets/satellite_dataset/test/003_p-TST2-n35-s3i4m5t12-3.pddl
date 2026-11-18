(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	satellite2 - satellite
	instrument4 - instrument
	instrument5 - instrument
	image4 - mode
	spectrograph0 - mode
	image2 - mode
	infrared1 - mode
	image3 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	Star6 - direction
	GroundStation11 - direction
	Star0 - direction
	GroundStation10 - direction
	GroundStation9 - direction
	Star8 - direction
	Star7 - direction
	Star5 - direction
	Star3 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 image4)
	(supports instrument0 image2)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(supports instrument1 image2)
	(supports instrument1 infrared1)
	(supports instrument1 image4)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 Star3)
	(calibration_target instrument1 Star0)
	(supports instrument2 image3)
	(supports instrument2 image4)
	(calibration_target instrument2 Star8)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument3 infrared1)
	(supports instrument3 image2)
	(calibration_target instrument3 GroundStation9)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star15)
	(supports instrument4 image2)
	(calibration_target instrument4 Star5)
	(calibration_target instrument4 Star7)
	(calibration_target instrument4 Star8)
	(supports instrument5 image3)
	(supports instrument5 image2)
	(supports instrument5 infrared1)
	(calibration_target instrument5 Star3)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation4)
)
(:goal (and
	(have_image Star12 image3)
	(have_image Star13 image4)
	(have_image Star14 infrared1)
	(have_image Star15 spectrograph0)
))

)
