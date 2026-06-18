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
	instrument5 - instrument
	thermograph2 - mode
	image1 - mode
	spectrograph4 - mode
	spectrograph0 - mode
	infrared3 - mode
	Star0 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	Star4 - direction
	Star2 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	Star9 - direction
	GroundStation11 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image1)
	(calibration_target instrument0 Star2)
	(supports instrument1 image1)
	(supports instrument1 infrared3)
	(calibration_target instrument1 Star2)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star4)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
	(supports instrument2 spectrograph4)
	(calibration_target instrument2 GroundStation8)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star9)
	(supports instrument3 thermograph2)
	(supports instrument3 infrared3)
	(supports instrument3 spectrograph0)
	(calibration_target instrument3 GroundStation8)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation1)
	(supports instrument4 infrared3)
	(calibration_target instrument4 Star9)
	(calibration_target instrument4 GroundStation10)
	(supports instrument5 image1)
	(supports instrument5 infrared3)
	(supports instrument5 spectrograph0)
	(calibration_target instrument5 GroundStation11)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star6)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(pointing satellite1 Star6)
	(have_image Star12 thermograph2)
	(have_image Star13 image1)
	(have_image Star14 spectrograph4)
	(have_image Planet15 image1)
))

)
