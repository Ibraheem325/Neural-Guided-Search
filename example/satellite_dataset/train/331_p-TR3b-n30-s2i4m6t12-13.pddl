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
	spectrograph0 - mode
	infrared3 - mode
	image5 - mode
	spectrograph4 - mode
	image1 - mode
	GroundStation4 - direction
	Star11 - direction
	Star7 - direction
	Star9 - direction
	GroundStation1 - direction
	Star0 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	Star8 - direction
	Star10 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(supports instrument1 thermograph2)
	(supports instrument1 image1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation1)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 GroundStation6)
	(calibration_target instrument1 Star10)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star10)
	(calibration_target instrument2 Star0)
	(supports instrument3 infrared3)
	(supports instrument3 image5)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 Star5)
	(supports instrument4 thermograph2)
	(calibration_target instrument4 Star8)
	(supports instrument5 image5)
	(supports instrument5 infrared3)
	(calibration_target instrument5 Star10)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation1)
)
(:goal (and
	(pointing satellite1 GroundStation4)
	(have_image Phenomenon12 spectrograph0)
	(have_image Phenomenon13 image5)
	(have_image Phenomenon13 spectrograph4)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon14 spectrograph4)
	(have_image Planet15 infrared3)
	(have_image Planet15 spectrograph0)
))

)
