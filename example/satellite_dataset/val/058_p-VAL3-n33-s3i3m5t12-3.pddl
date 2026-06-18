(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	instrument4 - instrument
	satellite2 - satellite
	instrument5 - instrument
	spectrograph0 - mode
	image2 - mode
	image3 - mode
	image4 - mode
	infrared1 - mode
	GroundStation2 - direction
	Star8 - direction
	GroundStation11 - direction
	Star3 - direction
	Star5 - direction
	Star6 - direction
	GroundStation4 - direction
	GroundStation10 - direction
	GroundStation1 - direction
	GroundStation9 - direction
	Star0 - direction
	Star7 - direction
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
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument2 image4)
	(supports instrument2 infrared1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star5)
	(supports instrument3 image3)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation9)
	(supports instrument4 infrared1)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 GroundStation9)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation10)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
	(supports instrument5 infrared1)
	(supports instrument5 spectrograph0)
	(supports instrument5 image2)
	(calibration_target instrument5 Star7)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star3)
)
(:goal (and
	(have_image Star12 image3)
	(have_image Star13 image4)
	(have_image Star14 infrared1)
	(have_image Star15 spectrograph0)
))

)
